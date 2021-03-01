const DataLoader = require('dataloader')

const {Customer: CustomerModel} = require('../models') 

module.exports = {
  customersloader: new DataLoader(async ids => await CustomerModel.findAll({
    where: {
      customerNumber: ids
    }
  }))
}