import { useMemo } from "react";
import { useTranslation } from "react-i18next";
import { useQuery } from "@tanstack/react-query";
import { z } from "zod";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { bcHttp } from "@/core/api/http";
import { useAppStore } from "@/store/app";
import { Invoice, Payment } from "@/types";
import { mockInvoices, mockPayments } from "@/utils/mock";
import { Card, CardContent, CardHeader } from "@/shared/ui/card";
import { Input } from "@/shared/ui/input";
import { Select } from "@/shared/ui/select";
import { Button } from "@/shared/ui/button";
import { Table, TH, THead, TRow, TD } from "@/shared/ui/table";

const schema = z.object({
  invoiceNo: z.string().min(1),
  amount: z.coerce.number().min(0),
  method: z.enum(["Cash", "Bank Transfer", "Credit Card", "Check"]),
  date: z.string().min(1),
});

type FormValues = z.infer<typeof schema>;

export const PaymentsPage = () => {
  const { t } = useTranslation();
  const demoMode = useAppStore((s) => s.demoMode);

  const { data: invoicesData } = useQuery({
    queryKey: ["invoices"],
    queryFn: async () => (await bcHttp.get("/invoices")).data?.value as Invoice[],
    initialData: demoMode ? mockInvoices : [],
    enabled: !demoMode,
  });

  const { data: paymentsData } = useQuery({
    queryKey: ["payments"],
    queryFn: async () => (await bcHttp.get("/payments")).data?.value as Payment[],
    initialData: demoMode ? mockPayments : [],
    enabled: !demoMode,
  });

  const invoices = useMemo(() => invoicesData || [], [invoicesData]);
  const payments = useMemo(() => paymentsData || [], [paymentsData]);

  const form = useForm<FormValues>({
    resolver: zodResolver(schema),
  });

  const onSubmit = (values: FormValues) => {
    if (demoMode) return;
    bcHttp.post("/payments", values);
  };

  return (
    <div className="space-y-6">
      <Card>
        <CardHeader>{t("payments.title")}</CardHeader>
        <CardContent>
          <form onSubmit={form.handleSubmit(onSubmit)} className="grid gap-4 md:grid-cols-4">
            <Select {...form.register("invoiceNo")}>
              <option value="">{t("payments.invoice")}</option>
              {invoices.map((inv) => (
                <option key={inv.id} value={inv.invoiceNo}>
                  {inv.invoiceNo}
                </option>
              ))}
            </Select>
            <Input type="number" placeholder={t("payments.amount")} {...form.register("amount")} />
            <Select {...form.register("method")}>
              <option value="Cash">Cash</option>
              <option value="Bank Transfer">Bank Transfer</option>
              <option value="Credit Card">Credit Card</option>
              <option value="Check">Check</option>
            </Select>
            <Input type="date" {...form.register("date")} />
            <div className="md:col-span-4">
              <Button type="submit">{t("common.save")}</Button>
            </div>
          </form>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>{t("payments.title")}</CardHeader>
        <CardContent>
          <Table>
            <THead>
              <TRow>
                <TH>{t("payments.invoice")}</TH>
                <TH>{t("payments.amount")}</TH>
                <TH>{t("payments.method")}</TH>
                <TH>{t("payments.date")}</TH>
              </TRow>
            </THead>
            <tbody>
              {payments.map((p) => (
                <TRow key={p.id}>
                  <TD>{p.invoiceNo}</TD>
                  <TD>${p.amount}</TD>
                  <TD>{p.method}</TD>
                  <TD>{p.date}</TD>
                </TRow>
              ))}
            </tbody>
          </Table>
        </CardContent>
      </Card>
    </div>
  );
};
