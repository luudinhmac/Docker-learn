const mongoose = require('mongoose')
const Schema = mongoose.Schema

const ProductSchema = new Schema({
  name: {
    type: String,
    required: true,
    trim: true
  },
  quantity: {
    type: Number,
    required: true
  },
  image: String,
  userCreated: {
    ref: 'User',
    required: true,
    type: Schema.Types.ObjectId
  }
}, { timestamps: true })

ProductSchema.statics.protectedFields = [
  '_id',
  '__v'
]

const Product = mongoose.model('Product', ProductSchema)

module.exports = Product
