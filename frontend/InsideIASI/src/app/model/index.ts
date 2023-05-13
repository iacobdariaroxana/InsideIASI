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
  distance: {
    text: string;
  };
  duration: {
    text: string;
  };
}

export interface Distance {
  number_of_km: string;
  eta: string;
}

export interface AddressDTO {
  formatted_address: string;
}

export interface Address {
  street: string;
  city: string;
  country: string;
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
  rating: string | number;
  lat: number;
  lng: number;
  open: string | undefined;
  distance: string;
  eta: string;
}

export interface HourWeatherInfo {
  startTime: Date;
  values: {
    humidity: number,
    precipitationProbability: number;
    temperature: number;
  }
}