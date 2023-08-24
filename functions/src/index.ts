import * as admin from "firebase-admin";
import * as cheerio from "cheerio";
import * as functions from "firebase-functions";
import { MessagingPayload } from "firebase-admin/lib/messaging/messaging-api";

admin.initializeApp();

// Put user in unit if access code is correct
export const onboardUserWithAccessCode = functions.https.onCall(async (data, context) => {
  const uid = context.auth?.uid;

  // Check if user is authenticated
  if(!uid){
    throw new functions.https.HttpsError("unauthenticated", "User not authenticated");
  }

  const payload = {
    [uid]: {
      name: data.name
    }
  }
  const code = data.accessCode;  

  // Find unit with provided access code
  const units = await admin.firestore().collection("units").where("access_code", "==", code).get();

  // Check if unit exists
  if(units.empty){
    throw new functions.https.HttpsError("not-found", "Unit not found");
  }

  // Assign user to unit
  const unit = units.docs[0];
  let tenants = unit.data().tenants ?? {};
  tenants = { ...tenants, ...payload };
  await unit.ref.set({ tenants: tenants }, { merge: true });
  
  return { success: true };
})


// Delete user from all units when user is deleted
export const onUserDeleted = functions.auth.user().onDelete(async (user) => {
  const units = await admin.firestore().collection("units").where(`tenants.${user.uid}`, "!=", null).get();

  const batch = units.docs.map((unit) => {
    const tenants = unit.data().tenants;
    delete tenants[user.uid];
    return unit.ref.set({ tenants }, { merge: true });
  });

  return Promise.all(batch);
});

export const onMessageCreated = functions.firestore.document("messages/{messageId}").onCreate(async (snapshot, context) => {
  const body = snapshot.data().body;
  
  if(body){
    const urls = extractUrlsFromString(body)
    if(urls){
      const batch: Promise<any>[] = [];
      urls?.map((url: string) => {
        batch.push(loadMeta(url));
      })
      const metadata = await Promise.all(batch);
      return snapshot.ref.set({ metadata }, { merge: true });
    }
  }
  
  // TODO: get strings from remote config
  return sendPushNotification("New message", body)
})

// Function to load meta information from a given URL
const loadMeta = async (url: string) => {

  // Fetch response of the url page
  const response = await fetch(url);

  // Extract the html file from the fetched request
  const html = await response.text();

  // Load the html content into a cheerio object
  const $ = cheerio.load(html);

  // Create an empty object to hold the metadata
  const metadata: any = {
    "url": url
  };

  // Iterate through all the meta tags to find Open Graph metadata
  $("meta").each((index: any, element: any) => {
    const property = $(element).attr("property");
    if (property && property.startsWith("og:")) {

      // Extract the og key value pair from the properties and add it to the metadata object
      const key = property.substring("og:".length);
      const value = $(element).attr("content");
      metadata[key] = value;
    }
  });

  // Return the final metadata object
  return metadata;
}


// This function extracts URLs from a string and returns them as an array.
const extractUrlsFromString = (string: string) => {
  // Regular expression for finding URLs in the string http or https
  const regex = /^(http|https):\/\//;
  // Use the match() method to search the provided string using the regular expression
  // and return an array of URLs found in the string.
  return string.match(regex);
}


// This function sends a push notification message.

// It takes three parameters:
//  * `title`: A string representing the title of the push notification.
//  * `body`: A string representing the body text of the push notification.
//  * `image`: A string representing the URL of an image to display in the push notification.
const sendPushNotification = (title: string, body: string, image?: string) => {

  // Construct the message payload using Firebase Cloud Messaging's recommended structure.
  const message = {
    data: {},
    notification: {
      title,
      body,
      imageUrl: image
    },
    topic: "default"
  } as MessagingPayload;

  // Return the result of sending the message payload to the "default" topic.
  return admin.messaging().sendToTopic("default", message)
}
