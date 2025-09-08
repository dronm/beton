import { openDB } from 'idb';

const dbPromise = openDB('app-db', 1, {
  upgrade(db) {
    db.createObjectStore('models');
  },
});

export async function cacheModel(modelName, data) {
  const db = await dbPromise;
  await db.put('models', data, modelName);
}

export async function getModel(modelName) {
  const db = await dbPromise;
  return db.get('models', modelName);
}

