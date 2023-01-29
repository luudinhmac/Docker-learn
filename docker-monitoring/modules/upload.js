const multer = require('multer')
const path = require('path')
const crypto = require('crypto')

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'public/images')
  },
  filename: (req, file, cb) => {
    cb(null, `${crypto.randomBytes(3).toString('hex')}${Date.now()}${path.extname(file.originalname)}`)
  }
})
const upload = multer({ storage: storage })

module.exports = upload
