import { LayoutGrid, Route, Users, CalendarDays, FileText } from "lucide-react";
import { RoleLayout } from "@/shared/layout/RoleLayout";

const navItems = [
  { to: "/agent", label: "Agent Dashboard", icon: <LayoutGrid size={18} /> },
  { to: "/agent/itinerary", label: "Itinerary Builder", icon: <Route size={18} /> },
  { to: "/agent/crm", label: "CRM", icon: <Users size={18} /> },
  { to: "/agent/reservations", label: "Reservations", icon: <CalendarDays size={18} /> },
  { to: "/agent/quotes", label: "Quotes", icon: <FileText size={18} /> },
];

export const AgentLayout = () => {
  return <RoleLayout navItems={navItems} brandLabel="Travel Agency ERP" />;
};
