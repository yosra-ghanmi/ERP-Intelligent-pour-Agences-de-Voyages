import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuthStore } from "@/store/auth";
import { Card, CardContent } from "@/shared/ui/card";

export const UserMenu = () => {
  const [open, setOpen] = useState(false);
  const { userEmail, role, signOut } = useAuthStore();
  const navigate = useNavigate();
  return (
    <div className="relative">
      <button onClick={() => setOpen((v) => !v)} className="rounded-full bg-accent px-3 py-2 text-sm">
        {userEmail?.slice(0, 2).toUpperCase() || "U"}
      </button>
      {open && (
        <div className="absolute right-0 top-12 w-56">
          <Card>
            <CardContent className="space-y-3">
              <div>
                <div className="text-sm font-medium">{userEmail || "user@erp.com"}</div>
                <div className="text-xs text-mutedForeground">{role || "TravelAgent"}</div>
              </div>
              <button
                onClick={() => {
                  navigate("/profile");
                  setOpen(false);
                }}
                className="w-full rounded-md border border-border px-3 py-2 text-sm"
              >
                Profile
              </button>
              <button onClick={signOut} className="w-full rounded-md border border-border px-3 py-2 text-sm">
                Sign out
              </button>
            </CardContent>
          </Card>
        </div>
      )}
    </div>
  );
};
