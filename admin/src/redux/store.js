import { combineReducers, configureStore } from '@reduxjs/toolkit';
import {
  FLUSH,
  PAUSE,
  PERSIST,
  persistReducer,
  persistStore,
  PURGE,
  REGISTER,
  REHYDRATE,
} from 'redux-persist';
import storage from 'redux-persist/lib/storage';

import rootReducer from './rootReducer';

const authPersistConfig = {
  key: 'auth',
  storage,
  whitelist: ['user'],
};
const settingsPersistConfig = {
  key: 'settings',
  storage,
  whitelist: ['settings'],
};
const themePersistConfig = {
  key: 'theme',
  storage,
  whitelist: ['theme'],
};
const ordersPersistConfig = {
  key: 'orders',
  storage,
  whitelist: ['layout'],
};
const todoPersistConfig = {
  key: 'todo',
  storage,
  whitelist: ['todos'],
};
const persistedReducer = combineReducers({
  ...rootReducer,
  auth: persistReducer(authPersistConfig, rootReducer.auth),
  globalSettings: persistReducer(
    settingsPersistConfig,
    rootReducer.globalSettings,
  ),
  orders: persistReducer(ordersPersistConfig, rootReducer.orders),
  theme: persistReducer(themePersistConfig, rootReducer.theme),
  todo: persistReducer(todoPersistConfig, rootReducer.todo),
});

export const store = configureStore({
  reducer: persistedReducer,
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: {
        ignoredActions: [FLUSH, REHYDRATE, PAUSE, PERSIST, PURGE, REGISTER],
      },
    }),
});

export const persistor = persistStore(store);
