import { ColumnDef, flexRender, getCoreRowModel, useReactTable } from "@tanstack/react-table";

export const DataTable = <T,>({ data, columns }: { data: T[]; columns: ColumnDef<T>[] }) => {
  const table = useReactTable({
    data,
    columns,
    getCoreRowModel: getCoreRowModel(),
  });

  return (
    <div className="glass-surface rounded-2xl shadow-[0_12px_30px_rgba(15,23,42,0.08)]">
      <table className="table-zebra w-full text-sm">
        <thead className="text-slate-600 uppercase tracking-wide text-xs dark:text-slate-300">
          {table.getHeaderGroups().map((headerGroup) => (
            <tr key={headerGroup.id} className="border-b border-border/70">
              {headerGroup.headers.map((header) => (
                <th key={header.id} className="px-4 py-4 text-left font-semibold text-slate-700 dark:text-slate-200">
                  {header.isPlaceholder ? null : flexRender(header.column.columnDef.header, header.getContext())}
                </th>
              ))}
            </tr>
          ))}
        </thead>
        <tbody>
          {table.getRowModel().rows.map((row) => (
            <tr key={row.id} className="border-b border-border/70">
              {row.getVisibleCells().map((cell) => (
                <td key={cell.id} className="px-4 py-4 text-slate-700 dark:text-slate-200">
                  {flexRender(cell.column.columnDef.cell, cell.getContext())}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};
