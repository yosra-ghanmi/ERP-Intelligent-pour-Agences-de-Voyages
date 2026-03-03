import { create } from "zustand";

type AppState = {
  theme: "light" | "dark";
  language: "en" | "fr";
  demoMode: boolean;
  selectedReservationId: string | null;
  selectedQuoteId: string | null;
  setTheme: (theme: "light" | "dark") => void;
  setLanguage: (language: "en" | "fr") => void;
  setDemoMode: (demo: boolean) => void;
  selectReservation: (id: string | null) => void;
  selectQuote: (id: string | null) => void;
};

export const useAppStore = create<AppState>((set) => ({
  theme: "light",
  language: "en",
  demoMode: true,
  selectedReservationId: null,
  selectedQuoteId: null,
  setTheme: (theme) => set({ theme }),
  setLanguage: (language) => set({ language }),
  setDemoMode: (demoMode) => set({ demoMode }),
  selectReservation: (id) => set({ selectedReservationId: id }),
  selectQuote: (id) => set({ selectedQuoteId: id }),
}));
