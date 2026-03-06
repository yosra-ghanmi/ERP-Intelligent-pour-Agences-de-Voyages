import { Navigate } from "react-router-dom";
import { ReactElement } from "react";
import { useAuthStore } from "@/store/auth";
import { Role } from "@/types";

const roleDashboard = (role: Role) => {
  if (role === "Admin") return "/admin";
  if (role === "Accountant") return "/finance";
  return "/agent";
};

export const ProtectedRoute = ({ children, allow }: { children: ReactElement; allow?: Role[] }) => {
  const token = useAuthStore((s) => s.token);
  const role = useAuthStore((s) => s.role);
  if (!token || !role) return <Navigate to="/login" replace />;
  if (allow && !allow.includes(role)) return <Navigate to={roleDashboard(role)} replace />;
  return children;
};
