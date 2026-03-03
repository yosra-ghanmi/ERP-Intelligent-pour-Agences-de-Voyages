import { useMemo } from "react";
import { useTranslation } from "react-i18next";
import { useQuery } from "@tanstack/react-query";
import { z } from "zod";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import toast from "react-hot-toast";
import { bcHttp, aiHttp } from "@/core/api/http";
import { useAppStore } from "@/store/app";
import { Client, Reservation, Service } from "@/types";
import { mockClients, mockReservations, mockServices } from "@/utils/mock";
import { Card, CardContent, CardHeader } from "@/shared/ui/card";
import { Input } from "@/shared/ui/input";
import { Select } from "@/shared/ui/select";
import { Button } from "@/shared/ui/button";
import { Table, TH, THead, TRow, TD } from "@/shared/ui/table";

const schema = z.object({
  clientId: z.string().min(1),
  serviceId: z.string().min(1),
  startDate: z.string().min(1),
  endDate: z.string().min(1),
  status: z.enum(["Pending", "Program Designed", "Confirmed", "Cancelled"]),
});

type FormValues = z.infer<typeof schema>;

export const ReservationsPage = () => {
  const { t } = useTranslation();
  const demoMode = useAppStore((s) => s.demoMode);

  const { data: clientsData } = useQuery({
    queryKey: ["clients"],
    queryFn: async () => (await bcHttp.get("/clients")).data?.value as Client[],
    initialData: demoMode ? mockClients : [],
    enabled: !demoMode,
  });

  const { data: servicesData } = useQuery({
    queryKey: ["services"],
    queryFn: async () => (await bcHttp.get("/services")).data?.value as Service[],
    initialData: demoMode ? mockServices : [],
    enabled: !demoMode,
  });

  const { data: reservationsData } = useQuery({
    queryKey: ["reservations"],
    queryFn: async () => (await bcHttp.get("/reservations")).data?.value as Reservation[],
    initialData: demoMode ? mockReservations : [],
    enabled: !demoMode,
  });

  const clients = useMemo(() => clientsData || [], [clientsData]);
  const services = useMemo(() => servicesData || [], [servicesData]);
  const reservations = useMemo(() => reservationsData || [], [reservationsData]);

  const form = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: { status: "Pending" },
  });

  const onSubmit = (values: FormValues) => {
    if (demoMode) return;
    bcHttp.post("/reservations", values);
  };

  const generateItinerary = async (reservationId: string) => {
    try {
      const res = await aiHttp.post("/generate", { reservationId });
      toast.success(res.data?.summary || "Itinerary generated");
    } catch {
      toast.error("Failed to generate itinerary");
    }
  };

  return (
    <div className="space-y-6">
      <Card>
        <CardHeader>{t("reservations.title")}</CardHeader>
        <CardContent>
          <form onSubmit={form.handleSubmit(onSubmit)} className="grid gap-4 md:grid-cols-5">
            <Select {...form.register("clientId")}>
              <option value="">{t("reservations.client")}</option>
              {clients.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.name}
                </option>
              ))}
            </Select>
            <Select {...form.register("serviceId")}>
              <option value="">{t("reservations.service")}</option>
              {services.map((s) => (
                <option key={s.id} value={s.id}>
                  {s.name}
                </option>
              ))}
            </Select>
            <Input type="date" {...form.register("startDate")} />
            <Input type="date" {...form.register("endDate")} />
            <Select {...form.register("status")}>
              <option value="Pending">Pending</option>
              <option value="Program Designed">Program Designed</option>
              <option value="Confirmed">Confirmed</option>
              <option value="Cancelled">Cancelled</option>
            </Select>
            <div className="md:col-span-5">
              <Button type="submit">{t("common.save")}</Button>
            </div>
          </form>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>{t("reservations.title")}</CardHeader>
        <CardContent>
          <Table>
            <THead>
              <TRow>
                <TH>{t("reservations.client")}</TH>
                <TH>{t("reservations.service")}</TH>
                <TH>{t("reservations.startDate")}</TH>
                <TH>{t("reservations.endDate")}</TH>
                <TH>{t("reservations.status")}</TH>
                <TH>{t("common.actions")}</TH>
              </TRow>
            </THead>
            <tbody>
              {reservations.map((r) => (
                <TRow key={r.id}>
                  <TD>{clients.find((c) => c.id === r.clientId)?.name}</TD>
                  <TD>{services.find((s) => s.id === r.serviceId)?.name}</TD>
                  <TD>{r.startDate}</TD>
                  <TD>{r.endDate}</TD>
                  <TD>{r.status}</TD>
                  <TD>
                    <Button variant="outline" onClick={() => generateItinerary(r.id)}>
                      {t("reservations.generateItinerary")}
                    </Button>
                  </TD>
                </TRow>
              ))}
            </tbody>
          </Table>
        </CardContent>
      </Card>
    </div>
  );
};
