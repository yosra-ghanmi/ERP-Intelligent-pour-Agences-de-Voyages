import { useAuthStore } from "@/store/auth";
import { DashboardPage } from "@/features/dashboard/DashboardPage";
import { ServicesPage } from "@/features/services/ServicesPage";
import { InvoicesPage } from "@/features/invoices/InvoicesPage";
import { Input } from "@/shared/ui/input";
import { Select } from "@/shared/ui/select";
import { Button } from "@/shared/ui/button";

export const HomePage = () => {
  const role = useAuthStore((s) => s.role);
  const content =
    role === "Accountant" ? <InvoicesPage /> : role === "TravelAgent" ? <ServicesPage /> : <DashboardPage />;
  return (
    <div className="space-y-8">
      <section className="relative h-[240px] max-h-[280px] overflow-hidden rounded-[24px] text-white shadow-soft md:h-[280px]">
        <div className="absolute inset-0 hero-bg" />
        <div className="absolute inset-0 bg-gradient-to-r from-slate-950/80 via-slate-950/55 to-slate-900/30" />
        <div className="relative px-8 py-10 md:px-12 md:py-12" data-aos="fade-right">
          <div className="max-w-2xl space-y-5">
            <p className="text-sm uppercase tracking-[0.3em] text-white/70">Travel Agency ERP</p>
            <h1 className="text-3xl font-semibold leading-tight md:text-5xl">
              Curate unforgettable journeys with a premium travel workspace
            </h1>
            <p className="text-base text-white/80 md:text-lg">
              Manage clients, services, and reservations in one modern platform built for travel professionals.
            </p>
          </div>
        </div>
      </section>
      <div className="-mt-10 px-3 md:px-10">
        <div className="glass-surface rounded-[24px] p-5 shadow-soft" data-aos="zoom-in">
          <div className="grid gap-3 md:grid-cols-4">
            <Input placeholder="Destination" className="bg-transparent" />
            <Input placeholder="Dates" className="bg-transparent" />
            <Select className="bg-transparent">
              <option value="">Travel style</option>
              <option value="leisure">Leisure</option>
              <option value="business">Business</option>
              <option value="adventure">Adventure</option>
            </Select>
            <Button className="w-full">Search</Button>
          </div>
        </div>
      </div>
      <div className="space-y-6">{content}</div>
    </div>
  );
};
