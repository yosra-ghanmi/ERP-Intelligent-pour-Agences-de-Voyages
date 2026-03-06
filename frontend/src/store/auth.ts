import { create } from "zustand";
import { Role } from "@/types";

const STORAGE_KEY = "travel_agency_erp_auth";

const loadAuth = () => {
  if (typeof window === "undefined") return { token: null, role: null, userEmail: null };
  const raw = localStorage.getItem(STORAGE_KEY);
  if (!raw) return { token: null, role: null, userEmail: null };
  try {
    const parsed = JSON.parse(raw) as { token: string | null; role: Role | null; userEmail: string | null };
    return {
      token: parsed.token ?? null,
      role: parsed.role ?? null,
      userEmail: parsed.userEmail ?? null,
    };
  } catch {
    return { token: null, role: null, userEmail: null };
  }
};

const persistAuth = (state: { token: string | null; role: Role | null; userEmail: string | null }) => {
  if (typeof window === "undefined") return;
  localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
};

type AuthState = {
  token: string | null;
  role: Role | null;
  userEmail: string | null;
  signIn: (token: string, role: Role, email: string) => void;
  signOut: () => void;
};

export const useAuthStore = create<AuthState>((set) => {
  const initial = loadAuth();
  return {
    token: initial.token,
    role: initial.role,
    userEmail: initial.userEmail,
    signIn: (token, role, email) => {
      const next = { token, role, userEmail: email };
      persistAuth(next);
      set(next);
    },
    signOut: () => {
      const next = { token: null, role: null, userEmail: null };
      persistAuth(next);
      set(next);
    },
  };
});
