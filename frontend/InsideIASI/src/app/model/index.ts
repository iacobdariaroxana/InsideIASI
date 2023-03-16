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
  place_id: string;
  rating: number;
  icon: string;
  opening_Hours: {
    openNow: boolean
  }
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
}

export interface CustomEvent1 extends Event {
  detail: {
    position: {
      longitude: number;
      latitude: number;
    };
  };
}