import { useMemo } from "react";
import { useTranslation } from "react-i18next";
import { useQuery } from "@tanstack/react-query";
import { z } from "zod";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { bcHttp } from "@/core/api/http";
import { useAppStore } from "@/store/app";
import { Client } from "@/types";
import { mockClients } from "@/utils/mock";
import { Card, CardContent, CardHeader } from "@/shared/ui/card";
import { Input } from "@/shared/ui/input";
import { Button } from "@/shared/ui/button";
import { DataTable } from "@/shared/components/DataTable";

const schema = z.object({
  name: z.string().min(2),
  email: z.string().email(),
  phone: z.string().min(5),
  preference: z.string().min(10),
});

type FormValues = z.infer<typeof schema>;

export const ClientsPage = () => {
  const { t } = useTranslation();
  const demoMode = useAppStore((s) => s.demoMode);

  const { data } = useQuery({
    queryKey: ["clients"],
    queryFn: async () => {
      const res = await bcHttp.get("/clients");
      return res.data?.value as Client[];
    },
    initialData: demoMode ? mockClients : [],
    enabled: !demoMode,
  });

  const clients = useMemo(() => data || [], [data]);

  const form = useForm<FormValues>({
    resolver: zodResolver(schema),
  });

  const onSubmit = (values: FormValues) => {
    if (demoMode) return;
    bcHttp.post("/clients", values);
  };

  return (
    <div className="space-y-6">
      <Card className="glass-surface">
        <CardHeader>{t("clients.title")}</CardHeader>
        <CardContent>
          <form onSubmit={form.handleSubmit(onSubmit)} className="grid gap-4 md:grid-cols-4">
            <Input placeholder={t("clients.name")} {...form.register("name")} />
            <Input placeholder={t("clients.email")} {...form.register("email")} />
            <Input placeholder={t("clients.phone")} {...form.register("phone")} />
            <textarea
              className="min-h-[120px] w-full rounded-xl border border-border bg-white/90 px-4 py-3 text-sm text-foreground shadow-[0_6px_18px_rgba(15,23,42,0.06)] outline-none transition focus:border-sky-300 focus:ring-2 focus:ring-sky-200 md:col-span-4"
              placeholder="Describe the client's dream vacation and specific needs for the AI to analyze..."
              rows={4}
              {...form.register("preference")}
            />
            <div className="md:col-span-4">
              <Button type="submit">{t("common.save")}</Button>
            </div>
          </form>
        </CardContent>
      </Card>

      <Card className="glass-surface">
        <CardHeader>{t("clients.title")}</CardHeader>
        <CardContent>
          <DataTable
            data={clients}
            columns={[
              { header: t("clients.name"), accessorKey: "name" },
              { header: t("clients.email"), accessorKey: "email" },
              { header: t("clients.phone"), accessorKey: "phone" },
              {
                header: t("clients.preference"),
                accessorKey: "preference",
                cell: ({ getValue }) => {
                  const value = String(getValue() ?? "");
                  return value.length > 50 ? `${value.slice(0, 50)}...` : value;
                },
              },
            ]}
          />
        </CardContent>
      </Card>
    </div>
  );
};
