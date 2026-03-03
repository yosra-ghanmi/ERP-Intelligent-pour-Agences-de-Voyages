import axios from "axios";
import { API } from "@/utils/config";
import { useAuthStore } from "@/store/auth";
import toast from "react-hot-toast";

export const bcHttp = axios.create({
  baseURL: API.businessCentral,
  timeout: 15000,
});

export const aiHttp = axios.create({
  baseURL: API.aiServer,
  timeout: 20000,
});

const addAuth = (config: any) => {
  const token = useAuthStore.getState().token;
  if (token) {
    config.headers = { ...config.headers, Authorization: `Bearer ${token}` };
  }
  return config;
};

const onError = (error: any) => {
  const config = error.config || {};
  config.__retryCount = config.__retryCount || 0;
  if (config.__retryCount < 1 && (!error.response || error.code === "ECONNABORTED")) {
    config.__retryCount += 1;
    return axios(config);
  }
  const message = error?.response?.data?.message || error.message || "Request failed";
  toast.error(message);
  return Promise.reject(error);
};

bcHttp.interceptors.request.use(addAuth);
aiHttp.interceptors.request.use(addAuth);
bcHttp.interceptors.response.use((r) => r, onError);
aiHttp.interceptors.response.use((r) => r, onError);
