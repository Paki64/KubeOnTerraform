// app.js - Backend Node.js/Express
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(morgan('combined'));

// In-memory data store (sostituibile con database)
let items = [
  { id: 1, name: 'Item 1', description: 'First item', price: 19.99 },
  { id: 2, name: 'Item 2', description: 'Second item', price: 29.99 },
  { id: 3, name: 'Item 3', description: 'Third item', price: 39.99 }
];

// Health check endpoints
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy', timestamp: new Date().toISOString() });
});

app.get('/ready', (req, res) => {
  res.status(200).json({ status: 'ready', timestamp: new Date().toISOString() });
});

// API Base route
app.get('/api', (req, res) => {
  res.json({
    message: 'Backend API is running',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      ready: '/ready',
      items: '/api/items',
      item: '/api/items/:id',
      users: '/api/users',
      auth: '/api/auth/login'
    }
  });
});

// Items CRUD operations
app.get('/api/items', (req, res) => {
  res.json({
    success: true,
    data: items,
    count: items.length
  });
});

app.get('/api/items/:id', (req, res) => {
  const item = items.find(i => i.id === parseInt(req.params.id));
  if (!item) {
    return res.status(404).json({ success: false, message: 'Item not found' });
  }
  res.json({ success: true, data: item });
});

app.post('/api/items', (req, res) => {
  const { name, description, price } = req.body;
  
  if (!name || !description || price === undefined) {
    return res.status(400).json({ 
      success: false, 
      message: 'Missing required fields: name, description, price' 
    });
  }
  
  const newItem = {
    id: items.length + 1,
    name,
    description,
    price: parseFloat(price)
  };
  
  items.push(newItem);
  res.status(201).json({ success: true, data: newItem });
});

app.put('/api/items/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const itemIndex = items.findIndex(i => i.id === id);
  
  if (itemIndex === -1) {
    return res.status(404).json({ success: false, message: 'Item not found' });
  }
  
  const { name, description, price } = req.body;
  items[itemIndex] = {
    ...items[itemIndex],
    ...(name && { name }),
    ...(description && { description }),
    ...(price !== undefined && { price: parseFloat(price) })
  };
  
  res.json({ success: true, data: items[itemIndex] });
});

app.delete('/api/items/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const itemIndex = items.findIndex(i => i.id === id);
  
  if (itemIndex === -1) {
    return res.status(404).json({ success: false, message: 'Item not found' });
  }
  
  const deletedItem = items.splice(itemIndex, 1)[0];
  res.json({ success: true, data: deletedItem });
});

// User endpoints (esempio)
app.get('/api/users', (req, res) => {
  res.json({
    success: true,
    data: [
      { id: 1, username: 'user1', email: 'user1@example.com' },
      { id: 2, username: 'user2', email: 'user2@example.com' }
    ]
  });
});

// Auth endpoint (esempio base)
app.post('/api/auth/login', (req, res) => {
  const { username, password } = req.body;
  
  if (!username || !password) {
    return res.status(400).json({ 
      success: false, 
      message: 'Username and password required' 
    });
  }
  
  // Simulazione login (in produzione usa bcrypt e JWT)
  if (username === 'admin' && password === 'password') {
    res.json({
      success: true,
      data: {
        token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.example.token',
        user: { username: 'admin', role: 'administrator' }
      }
    });
  } else {
    res.status(401).json({ success: false, message: 'Invalid credentials' });
  }
});

// Stats endpoint
app.get('/api/stats', (req, res) => {
  res.json({
    success: true,
    data: {
      totalItems: items.length,
      totalValue: items.reduce((sum, item) => sum + item.price, 0),
      averagePrice: items.length > 0 ? 
        items.reduce((sum, item) => sum + item.price, 0) / items.length : 0,
      timestamp: new Date().toISOString()
    }
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ 
    success: false, 
    message: 'Endpoint not found',
    path: req.path 
  });
});

// Error handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ 
    success: false, 
    message: 'Internal server error',
    error: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`Backend server is running on port ${PORT}`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
});