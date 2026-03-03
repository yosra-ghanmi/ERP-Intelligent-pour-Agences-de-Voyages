import { useAuthStore } from "@/store/auth";
import { Card, CardContent, CardHeader } from "@/shared/ui/card";

export const ProfilePage = () => {
  const { userEmail, role } = useAuthStore();
  return (
    <Card>
      <CardHeader>User Profile</CardHeader>
      <CardContent className="space-y-3">
        <div>
          <div className="text-xs text-mutedForeground">Email</div>
          <div className="text-sm font-medium">{userEmail || "user@erp.com"}</div>
        </div>
        <div>
          <div className="text-xs text-mutedForeground">Role</div>
          <div className="text-sm font-medium">{role || "TravelAgent"}</div>
        </div>
      </CardContent>
    </Card>
  );
};
