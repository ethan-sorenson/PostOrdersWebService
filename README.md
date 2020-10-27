# Post Orders Web Service
This extension creates a web service for posting transactions.

<ins>The Extension now supports the following entities:</ins>
* Sales Order
* Sales Invoice
* Sales Credit Memo
* Purchase Order
* Purchase Invoice
* Purchase Credit Memo

The standard Business Central web services support posting transactions with bound services as documented [here](https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-creating-and-interacting-with-odatav4-bound-action). This method does not work with SmartConnect or allow batch posting.

### Overview
This Extension recreates the Batch Posting window seen below. 
The Codeunits [Cod50213.SCSalesPostingProcedures.al](Cod50213.SCSalesPostingProcedures.al) and [Cod50214.SCPurchPostingProcedures.al](Cod50214.SCPurchPostingProcedures.al) use the standard posting codeunits to post the batches.

![increment](https://i.imgur.com/nGg8btl.gif)

### Getting Started
1. If you aren't familar with building AL extensions you can use the Microsoft [documentation](https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-dev-overview "documentation") to get started.
2. The [Tab50210.SCPostTransactions.al](Tab50210.SCPostTransactions.al) file can be modified as needed to use additional logic.
3. After publishing the extension you will be able to post batches using a json format similar to [Sample.json](Sample.json)

### Troubleshooting
**Web Service isn't available after publishing**
* Make sure the service is published as outlined [here](https://docs.microsoft.com/en-us/dynamics365/business-central/across-how-publish-web-service "documentation").
* Make sure the service is named as expected ex. /ODataV4/Company('Sample')/SCPostTransactionBatch

**Something else isn't working properly**
* Use github's issue reporter on the right
* Send me an email ethan.sorenson@eonesolutions.com (might take a few days)

### Updates
* 1.0.0.1 first release on BC v14
* 1.0.0.2 updated for BC v16, added support for Purchase Transactions
* 1.0.0.3 updated for BC v17, replaced obsolete references

***Enjoy!***