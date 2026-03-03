import { useMemo } from "react";
import { GoogleMap, Marker, useLoadScript } from "@react-google-maps/api";
import { GOOGLE_MAPS_API_KEY } from "@/utils/config";

type Props = {
  lat: number;
  lng: number;
  onSelect: (lat: number, lng: number) => void;
};

export const ServiceMap = ({ lat, lng, onSelect }: Props) => {
  const center = useMemo(() => ({ lat, lng }), [lat, lng]);
  const { isLoaded } = useLoadScript({
    googleMapsApiKey: GOOGLE_MAPS_API_KEY || "",
  });

  if (!GOOGLE_MAPS_API_KEY) {
    return <div className="flex h-64 items-center justify-center rounded-md border border-border">Missing Google Maps API key</div>;
  }

  if (!isLoaded) {
    return <div className="flex h-64 items-center justify-center rounded-md border border-border">Loading map...</div>;
  }

  return (
    <GoogleMap
      zoom={8}
      center={center}
      mapContainerClassName="h-64 w-full rounded-md"
      onClick={(e) => onSelect(e.latLng?.lat() || lat, e.latLng?.lng() || lng)}
    >
      <Marker position={center} />
    </GoogleMap>
  );
};
