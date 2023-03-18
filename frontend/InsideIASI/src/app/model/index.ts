export interface PointOfInterest {
  position: {
    lat: number;
    lng: number;
  };
  name: string;
  icon: string;
  rating: number;
  open_now: boolean;
}

export interface PointOfInterestDTO {
  geometry: {
    location: {
      lat: number;
      lng: number;
    };
  };
  name: string;
  placeid: string;
  rating: number;
  icon: string;
  openingHours: {
    open_Now: boolean;
  };
}

export interface DistanceDTO {
  numberOfKilometers: {
    text: string;
  };
  estimatedTime: {
    text: string;
  };
}

export interface Distance {
  number_of_km: number;
  eta: number;
}

export interface Marker {
  position: {
    lat: number;
    lng: number;
  };
  label: {
    color: string;
    text: string;
  };
  title: string;
  options: {
    animation: google.maps.Animation;
  };
  icon: {
    url: string;
    scaledSize: google.maps.Size;
  };
  rating: number;
  open_now: boolean;
}

export interface MarkerInfo {
  name: string;
  rating: string;
  lat: number;
  lng: number;
  open: string;
  distance: number;
  eta: number;
}
