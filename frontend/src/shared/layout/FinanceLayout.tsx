import { LayoutGrid, BookOpen, ReceiptText, BarChart3, CreditCard } from "lucide-react";
import { RoleLayout } from "@/shared/layout/RoleLayout";

const navItems = [
  { to: "/finance", label: "Finance Dashboard", icon: <LayoutGrid size={18} /> },
  { to: "/finance/ledger", label: "Ledger", icon: <BookOpen size={18} /> },
  { to: "/finance/expenses", label: "Expense Tracking", icon: <ReceiptText size={18} /> },
  { to: "/finance/reports", label: "Financial Reports", icon: <BarChart3 size={18} /> },
  { to: "/finance/invoices", label: "Invoices", icon: <ReceiptText size={18} /> },
  { to: "/finance/payments", label: "Payments", icon: <CreditCard size={18} /> },
];

export const FinanceLayout = () => {
  return <RoleLayout navItems={navItems} brandLabel="Travel Agency ERP" />;
};
