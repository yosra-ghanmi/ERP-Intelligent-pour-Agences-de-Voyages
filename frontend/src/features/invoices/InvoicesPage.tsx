import { useMemo } from "react";
import { useTranslation } from "react-i18next";
import { useQuery } from "@tanstack/react-query";
import { bcHttp } from "@/core/api/http";
import { useAppStore } from "@/store/app";
import { Invoice } from "@/types";
import { mockInvoices } from "@/utils/mock";
import { Card, CardContent, CardHeader } from "@/shared/ui/card";
import { Table, TH, THead, TRow, TD } from "@/shared/ui/table";

export const InvoicesPage = () => {
  const { t } = useTranslation();
  const demoMode = useAppStore((s) => s.demoMode);

  const { data } = useQuery({
    queryKey: ["invoices"],
    queryFn: async () => (await bcHttp.get("/invoices")).data?.value as Invoice[],
    initialData: demoMode ? mockInvoices : [],
    enabled: !demoMode,
  });

  const invoices = useMemo(() => data || [], [data]);

  return (
    <Card>
      <CardHeader>{t("invoices.title")}</CardHeader>
      <CardContent>
        <Table>
          <THead>
            <TRow>
              <TH>{t("invoices.invoiceNo")}</TH>
              <TH>{t("invoices.quoteNo")}</TH>
              <TH>{t("invoices.status")}</TH>
              <TH>{t("invoices.total")}</TH>
              <TH>{t("invoices.balance")}</TH>
            </TRow>
          </THead>
          <tbody>
            {invoices.map((inv) => (
              <TRow key={inv.id}>
                <TD>{inv.invoiceNo}</TD>
                <TD>{inv.quoteNo}</TD>
                <TD>{inv.status}</TD>
                <TD>${inv.total}</TD>
                <TD>${inv.balance}</TD>
              </TRow>
            ))}
          </tbody>
        </Table>
      </CardContent>
    </Card>
  );
};
