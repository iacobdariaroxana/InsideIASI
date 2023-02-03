export interface PointOfInterest {
  position: {
    lat: number;
    lng: number;
  };
  name: string;
  icon: string;
  rating: number;
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
}

export interface Marker {
  position: {
    lat: number,
    lng: number
  },
  label: {
    color: string,
    text: string
  }
  title: string,
  options: {
    animation: google.maps.Animation
  },
  icon: {
    url: string,
    scaledSize: google.maps.Size
  },
  rating: number
}
