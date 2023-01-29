const User = require('../models/User')

class UserController {
  static async login (req, res, next) {
    try {
      req.session.save()

      return res.redirect('/')
    } catch (error) {
      return res.status(500).send('Server error')
    }
  }

  static logout (req, res, next) {
    try {
      req.logout()

      return res.redirect('/login')
    } catch (e) {
      return res.redirect('/login')
    }
  }

  static async register (req, res, next) {
    try {
      if (!req.body.email || !req.body.email.trim().length) {
        return res.status(422).json({
          message: 'Email is required!'
        })
      }

      if (!req.body.password || !req.body.password.trim().length) {
        return res.status(422).json({
          message: 'Password is required!'
        })
      }

      const user = new User({
        email: req.body.email,
        password: req.body.password
      })

      await user.save()

      req.flash('success_message', 'Successfully created account!')

      return res.redirect('/login')
    } catch (error) {
      return res.status(500).send('Server error')
    }
  }
}

module.exports = UserController
