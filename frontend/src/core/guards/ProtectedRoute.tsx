import { Navigate } from "react-router-dom";
import { ReactElement } from "react";
import { useAuthStore } from "@/store/auth";

export const ProtectedRoute = ({ children }: { children: ReactElement }) => {
  const token = useAuthStore((s) => s.token);
  if (!token) return <Navigate to="/login" replace />;
  return children;
};
