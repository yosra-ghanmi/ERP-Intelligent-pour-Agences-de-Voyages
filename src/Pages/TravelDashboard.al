page 50647 "Travel Dashboard"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Travel Dashboard';
    SourceTable = "Travel Dashboard Cue";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(KPIs)
            {
                Caption = 'Key Performance Indicators';
                ShowCaption = false;

                cuegroup(General)
                {
                    Caption = 'General';

                    field("Total Clients"; Rec."Total Clients")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Total number of clients.';
                    }
                    field("Total Reservations"; Rec."Total Reservations")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Total number of reservations.';
                    }
                    field("Pending Quotes"; Rec."Pending Quotes")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Number of quotes with status Sent.';
                    }
                    field("Total Revenue"; Rec."Total Revenue")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Total revenue from paid invoices.';
                    }
                }

                cuegroup(Calculated)
                {
                    Caption = 'Calculated KPIs';

                    field("Monthly Revenue"; Rec."Monthly Revenue")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Revenue for the current month.';
                    }
                    field("Top Destination"; Rec."Top Destination")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Most visited location.';
                    }
                    field("Conversion Rate"; Rec."Conversion Rate")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Percentage of quotes converted to invoices.';
                    }
                }
            }

            group(Charts)
            {
                Caption = 'Charts';

                group(Row1)
                {
                    ShowCaption = false;

                    group(Chart1)
                    {
                        Caption = 'Revenue by Month';
                        usercontrol(RevenueByMonthChart; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                        {
                            ApplicationArea = All;
                            trigger AddInReady()
                            begin
                                IsRevByMonthReady := true;
                                UpdateRevenueByMonthChart();
                            end;
                        }
                    }
                    group(Chart2)
                    {
                        Caption = 'Reservations by Status';
                        usercontrol(ResByStatusChart; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                        {
                            ApplicationArea = All;
                            trigger AddInReady()
                            begin
                                IsResByStatusReady := true;
                                UpdateResByStatusChart();
                            end;
                        }
                    }
                }

                group(Row2)
                {
                    ShowCaption = false;

                    group(Chart3)
                    {
                        Caption = 'Top 5 Services';
                        usercontrol(TopServicesChart; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                        {
                            ApplicationArea = All;
                            trigger AddInReady()
                            begin
                                IsTopServicesReady := true;
                                UpdateTopServicesChart();
                            end;
                        }
                    }
                    group(Chart4)
                    {
                        Caption = 'Revenue by Service Type';
                        usercontrol(RevByServiceChart; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                        {
                            ApplicationArea = All;
                            trigger AddInReady()
                            begin
                                IsRevByServiceReady := true;
                                UpdateRevByServiceChart();
                            end;
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RefreshData)
            {
                ApplicationArea = All;
                Caption = 'Refresh Dashboard';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    RefreshDashboard();
                end;
            }
        }
    }

    var
        IsRevByMonthReady: Boolean;
        IsResByStatusReady: Boolean;
        IsTopServicesReady: Boolean;
        IsRevByServiceReady: Boolean;

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
        RefreshDashboard();
    end;

    local procedure RefreshDashboard()
    var
        DashCalc: Codeunit "Dashboard Calculations";
    begin
        Rec.CalcFields("Total Clients", "Total Reservations", "Pending Quotes", "Total Revenue");

        Rec."Monthly Revenue" := DashCalc.CalculateMonthlyRevenue();
        Rec."Top Destination" := DashCalc.CalculateTopDestination();
        Rec."Conversion Rate" := DashCalc.CalculateConversionRate();
        Rec.Modify();

        UpdateRevenueByMonthChart();
        UpdateResByStatusChart();
        UpdateTopServicesChart();
        UpdateRevByServiceChart();
    end;

    local procedure UpdateRevenueByMonthChart()
    var
        BusChartBuf: Record "Business Chart Buffer";
        DashCalc: Codeunit "Dashboard Calculations";
    begin
        if not IsRevByMonthReady then exit;
        DashCalc.PopulateRevenueByMonth(BusChartBuf);
        BusChartBuf.Update(CurrPage.RevenueByMonthChart);
    end;

    local procedure UpdateResByStatusChart()
    var
        BusChartBuf: Record "Business Chart Buffer";
        DashCalc: Codeunit "Dashboard Calculations";
    begin
        if not IsResByStatusReady then exit;
        DashCalc.PopulateResByStatus(BusChartBuf);
        BusChartBuf.Update(CurrPage.ResByStatusChart);
    end;

    local procedure UpdateTopServicesChart()
    var
        BusChartBuf: Record "Business Chart Buffer";
        DashCalc: Codeunit "Dashboard Calculations";
    begin
        if not IsTopServicesReady then exit;
        DashCalc.PopulateTopServices(BusChartBuf);
        BusChartBuf.Update(CurrPage.TopServicesChart);
    end;

    local procedure UpdateRevByServiceChart()
    var
        BusChartBuf: Record "Business Chart Buffer";
        DashCalc: Codeunit "Dashboard Calculations";
    begin
        if not IsRevByServiceReady then exit;
        DashCalc.PopulateRevByServiceType(BusChartBuf);
        BusChartBuf.Update(CurrPage.RevByServiceChart);
    end;
}
