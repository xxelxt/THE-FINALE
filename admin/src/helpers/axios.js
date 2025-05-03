import axios from 'axios';
import { api_url, api_url_admin } from '../configs/app-global';

export const AxiosObject = async (type = 'token') => {
  return axios.create({
    baseURL: type === 'token' ? api_url_admin : api_url,
    timeout: 10000,
  });
};
