const bcrypt = require('bcryptjs')
const passport = require('passport')
const passportLocal = require('passport-local')
const User = require('../models/User')
const LocalStrategy = passportLocal.Strategy

passport.use(new LocalStrategy({
  usernameField: 'email',
  passReqToCallback: true
}, async (req, email, password, done) => {
  try {
    const user = await User.findOne({ email }).select('+password')

    if (!user) {
      return done(null, false, { message: req.flash('message', 'Email or password is incorrect') })
    }

    if (!bcrypt.compareSync(password, user.password)) {
      return done(null, false, { message: req.flash('message', 'Email or password is incorrect') })
    }

    const returnedUser = {
      _id: user._id,
      email: user.email
    }

    return done(null, returnedUser)
  } catch (e) {
    return done(e, { message: req.flash('message', 'Email or password is incorrect') })
  }
}))

passport.serializeUser((user, done) => {
  done(null, user._id)
})

passport.deserializeUser(async (userId, done) => {
  try {
    const user = await User.findById(userId)
    return done(null, user)
  } catch (e) {
    return done(e)
  }
})

module.exports = passport
