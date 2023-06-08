exports.update_stripe_customer = functions.region("europe-west2").pubsub.schedule(" * * * * * ").onRun(async (context) => {
  const users = await admin.firestore().collection("users").get();

  for (const doc of users.docs) {
    const customerDoc = await doc.ref.collection("stripe").doc("customer").get();
    if (customerDoc.exists) {
      const customer = await stripe.customers.retrieve(
          customerDoc.data().id,
      );

      await admin.firestore().collection("users").doc(doc.id).collection("stripe").doc("customer").update(customer);
      functions.logger.info(`user uid: ${doc.id}`, {structuredData: true});
      functions.logger.info(`user customer: ${customerDoc.data().id}`, {structuredData: true});
      break;
    }
  }
  console.log("All existing stripe customer data updated!");
});
