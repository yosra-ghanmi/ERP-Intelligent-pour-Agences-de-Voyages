import { create } from "zustand";
import { Role } from "@/types";

type AuthState = {
  token: string | null;
  role: Role | null;
  userEmail: string | null;
  signIn: (token: string, role: Role, email: string) => void;
  signOut: () => void;
};

export const useAuthStore = create<AuthState>((set) => ({
  token: null,
  role: null,
  userEmail: null,
  signIn: (token, role, email) => set({ token, role, userEmail: email }),
  signOut: () => set({ token: null, role: null, userEmail: null }),
}));
