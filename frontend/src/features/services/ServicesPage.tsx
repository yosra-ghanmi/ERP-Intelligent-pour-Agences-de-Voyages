import { useMemo, useState } from "react";
import { useTranslation } from "react-i18next";
import { useQuery } from "@tanstack/react-query";
import { z } from "zod";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { bcHttp } from "@/core/api/http";
import { useAppStore } from "@/store/app";
import { Service } from "@/types";
import { mockServices } from "@/utils/mock";
import { Card, CardContent, CardHeader } from "@/shared/ui/card";
import { Input } from "@/shared/ui/input";
import { Select } from "@/shared/ui/select";
import { Button } from "@/shared/ui/button";
import { Table, TH, THead, TRow, TD } from "@/shared/ui/table";
import { ServiceMap } from "@/features/maps/ServiceMap";

const schema = z.object({
  name: z.string().min(2),
  type: z.enum(["Hotel", "Flight", "Tour", "Activity"]),
  location: z.string().min(2),
  price: z.coerce.number().min(0),
  latitude: z.coerce.number(),
  longitude: z.coerce.number(),
});

type FormValues = z.infer<typeof schema>;

export const ServicesPage = () => {
  const { t } = useTranslation();
  const demoMode = useAppStore((s) => s.demoMode);
  const [coords, setCoords] = useState({ lat: 36.8065, lng: 10.1815 });

  const { data } = useQuery({
    queryKey: ["services"],
    queryFn: async () => {
      const res = await bcHttp.get("/services");
      return res.data?.value as Service[];
    },
    initialData: demoMode ? mockServices : [],
    enabled: !demoMode,
  });

  const form = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: {
      name: "",
      type: "Hotel",
      location: "",
      price: 0,
      latitude: coords.lat,
      longitude: coords.lng,
    },
  });

  const services = useMemo(() => data || [], [data]);

  const onSubmit = (values: FormValues) => {
    if (demoMode) return;
    bcHttp.post("/services", values);
  };

  return (
    <div className="space-y-6">
      <Card>
        <CardHeader>{t("services.title")}</CardHeader>
        <CardContent>
          <form onSubmit={form.handleSubmit(onSubmit)} className="grid gap-4 md:grid-cols-3">
            <Input placeholder={t("services.name")} {...form.register("name")} />
            <Select {...form.register("type")}>
              <option value="Hotel">Hotel</option>
              <option value="Flight">Flight</option>
              <option value="Tour">Tour</option>
              <option value="Activity">Activity</option>
            </Select>
            <Input placeholder={t("services.location")} {...form.register("location")} />
            <Input type="number" placeholder={t("services.price")} {...form.register("price")} />
            <Input type="number" placeholder={t("services.latitude")} {...form.register("latitude")} />
            <Input type="number" placeholder={t("services.longitude")} {...form.register("longitude")} />
            <div className="md:col-span-3">
              <ServiceMap
                lat={coords.lat}
                lng={coords.lng}
                onSelect={(lat, lng) => {
                  setCoords({ lat, lng });
                  form.setValue("latitude", lat);
                  form.setValue("longitude", lng);
                }}
              />
            </div>
            <div className="md:col-span-3">
              <Button type="submit">{t("services.add")}</Button>
            </div>
          </form>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>{t("services.title")}</CardHeader>
        <CardContent>
          <Table>
            <THead>
              <TRow>
                <TH>{t("services.name")}</TH>
                <TH>{t("services.type")}</TH>
                <TH>{t("services.location")}</TH>
                <TH>{t("services.price")}</TH>
              </TRow>
            </THead>
            <tbody>
              {services.map((s) => (
                <TRow key={s.id}>
                  <TD>{s.name}</TD>
                  <TD>{s.type}</TD>
                  <TD>{s.location}</TD>
                  <TD>${s.price}</TD>
                </TRow>
              ))}
            </tbody>
          </Table>
        </CardContent>
      </Card>
    </div>
  );
};
