const express = require('express')
const router = express.Router()
const passport = require('passport')
const middlewares = require('../middlewares')
const upload = require('../modules/upload')

const UserController = require('../controllers/UserController')
const ProductController = require('../controllers/ProductController')

router.get('/login', (req, res, next) => {
  res.render('auth/login', {
    title: 'Login',
    message: req.flash('message'),
    error: req.flash('error'),
    success_message: req.flash('success_message')
  })
})

router.post('/login', passport.authenticate('local', {
  failureRedirect: '/login',
  failureFlash: true
}), UserController.login)

router.get('/register', (req, res, next) => {
  res.render('auth/register', { title: 'Register' })
})

router.post('/register', UserController.register)

router.post('/logout', middlewares.isAuthenticated, UserController.logout)

router.get('/', middlewares.isAuthenticated, ProductController.index)

router.post('/products', [middlewares.isAuthenticated, upload.single('product_image')], ProductController.store)

module.exports = router
