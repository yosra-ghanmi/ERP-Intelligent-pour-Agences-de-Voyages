import { LayoutGrid, Users, ScrollText, LineChart } from "lucide-react";
import { RoleLayout } from "@/shared/layout/RoleLayout";

const navItems = [
  { to: "/admin", label: "Overview", icon: <LayoutGrid size={18} /> },
  { to: "/admin/users", label: "User Management", icon: <Users size={18} /> },
  { to: "/admin/logs", label: "System Logs", icon: <ScrollText size={18} /> },
  { to: "/admin/analytics", label: "Global Analytics", icon: <LineChart size={18} /> },
];

export const AdminLayout = () => {
  return <RoleLayout navItems={navItems} brandLabel="Travel Agency ERP" />;
};
