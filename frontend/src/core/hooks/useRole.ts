import { useAuthStore } from "@/store/auth";

export const useRole = () => {
  return useAuthStore((s) => s.role);
};
