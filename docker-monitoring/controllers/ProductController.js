const Product = require('../models/Product')

class ProductController {
  static async store (req, res, next) {
    try {
      if (!req.body.product_name || !req.body.product_name.trim().length) {
        return res.status(422).json({
          message: 'Product name is required!'
        })
      }

      if (!req.body.product_quantity || !req.body.product_quantity.trim().length) {
        return res.status(422).json({
          message: 'Product quantity is required!'
        })
      }

      const product = new Product({
        name: req.body.product_name,
        quantity: parseInt(req.body.product_quantity, 10),
        image: req.file ? req.file.path : undefined,
        userCreated: req.user._id
      })

      await product.save()

      return res.redirect('/')
    } catch (error) {
      console.log(error)
      console.log('ERROR')
    }
  }

  static async index (req, res, next) {
    try {
      const products = await Product.find({ userCreated: req.user._id })

      return res.render('index', { title: 'Home', products, user: req.user })
    } catch (error) {
      console.log(error)
      console.log('error')
    }
  }
}

module.exports = ProductController
