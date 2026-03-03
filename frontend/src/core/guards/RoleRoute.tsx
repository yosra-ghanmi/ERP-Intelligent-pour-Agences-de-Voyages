import { Navigate } from "react-router-dom";
import { ReactElement } from "react";
import { Role } from "@/types";
import { useAuthStore } from "@/store/auth";

export const RoleRoute = ({ children, allow }: { children: ReactElement; allow: Role[] }) => {
  const role = useAuthStore((s) => s.role);
  if (!role || !allow.includes(role)) return <Navigate to="/" replace />;
  return children;
};
