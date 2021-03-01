const {Payment: PaymentModel} = require('../models')

class Payment {
  constructor(model) {
    this.model = model
  }

  async findAll() {
    return await this.model.findAll()
  }

  async deleteOne(checkNumber) {
    let result = await this.model.destroy({
      where: {
        checkNumber: checkNumber
      }
    })
    return Boolean(result)
  }
}

module.exports = new Payment(PaymentModel)