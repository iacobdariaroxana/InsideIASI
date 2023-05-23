import {
  Component,
  OnInit,
  QueryList,
  ViewChild,
  ViewChildren,
} from '@angular/core';
import { GoogleMap, MapInfoWindow } from '@angular/google-maps';
import { first } from 'rxjs';
import { Address, Marker, MarkerInfo } from 'src/app/model';
import { MapService } from './services/map.service';
import { Geolocation } from '@capacitor/geolocation';
import { ActivatedRoute } from '@angular/router';
import { openGoogleMaps } from './utils';
import { TranslateService } from '@ngx-translate/core';


@Component({
  selector: 'app-google-maps',
  templateUrl: './google-maps.component.html',
  styleUrls: ['./google-maps.component.scss'],
})
export class GoogleMapsComponent implements OnInit {
  @ViewChild(GoogleMap) map!: GoogleMap;
  @ViewChildren(MapInfoWindow) infoWindow!: QueryList<MapInfoWindow>;

  center: google.maps.LatLngLiteral = {
    lat: 47.186931656055684,
    lng: 27.553303223560913,
  };
  markers!: Marker[];
  options: google.maps.MapOptions = {
    styles: [
      {
        featureType: 'poi',
        stylers: [{ visibility: 'off' }],
      },
    ],
    zoom: 16,
    minZoom: 12.5,
  };
  poiInfo: MarkerInfo = {
    name: '',
    rating: '',
    lat: 0,
    lng: 0,
    distance: '0',
    eta: '0',
    open: undefined,
  };
  userLocation: google.maps.LatLngLiteral = {
    lat: 47.186931656055684,
    lng: 27.553303223560913,
  };
  userLocationInfo: Address = {
    street: '',
    city: '',
    country: '',
  };

  constructor(
    private readonly _mapService: MapService,
    private readonly _route: ActivatedRoute,
    private _translate: TranslateService
  ) {}

  ngOnInit(): void {
    this.setInitialPosition();
    // setInterval(() => this.setCurrentPosition(), 60 * 1000);
    this._route.queryParams.subscribe((params) => {
      this.getMarkers(params['query']);
    });
  }

  setInitialPosition = async () => {
    await Geolocation.getCurrentPosition({ enableHighAccuracy: true })
      .then((response) => {
        this.center = {
          lat: response.coords.latitude,
          lng: response.coords.longitude,
        };
        this.userLocation = this.center;
      })
      .catch(async (err) => {
        console.log(err);
      });
  };

  setCurrentPosition = async () => {
    await Geolocation.getCurrentPosition({ enableHighAccuracy: true })
      .then((response) => {
        this.userLocation = {
          lat: response.coords.latitude,
          lng: response.coords.longitude,
        };
      })
      .catch(async (err) => {
        console.log(err);
      });
  };

  setCenterToUserLocation() {
    this.center = this.userLocation;
    this.map.panTo(this.center);
  }

  setDistanceAndETA(lat: number, lng: number) {
    const userLat = this.userLocation.lat;
    const userLng = this.userLocation.lng;
    this._mapService
      .getDistanceBetweenPlaces(userLat, userLng, lat, lng)
      .pipe(first())
      .subscribe({
        next: (distance) => {
          this.poiInfo.distance = distance.number_of_km;
          this.poiInfo.eta = distance.eta;
        },
        error: (err) => {
          console.log(err);
        },
      });
  }

  getMarkers(query: string) {
    this._mapService
      .getPointsOfInterest(this.center.lat, this.center.lng, query)
      .pipe(first())
      .subscribe({
        next: (pointsOfInterest) => {
          this.markers = pointsOfInterest.map((pointOfInterest) => {
            return {
              position: {
                lat: pointOfInterest.position.lat,
                lng: pointOfInterest.position.lng,
              },
              label: {
                color: 'white',
                text: ' ',
              },
              title: pointOfInterest.name,
              options: {
                animation: google.maps.Animation.BOUNCE,
              },
              icon: {
                url: `../../assets/images/${query}.png`,
                scaledSize: new google.maps.Size(32, 32),
              },
              rating: pointOfInterest.rating,
              open_now: pointOfInterest.open_now,
            };
          });
        },
        error: (err) => {
          console.log(err);
        },
      });
  }

  openPoiInfo(
    marker: any,
    name: string,
    rating: number,
    lat: number,
    lng: number,
    open: boolean
  ) {
    this.center = {
      lat: lat,
      lng: lng,
    };

    this.poiInfo.name = name;
    // rating == 0 ? (this.info.rating = '0') : (this.info.rating = `${rating}`);
    this.poiInfo.lat = lat;
    this.poiInfo.lng = lng;
    if (rating != 0) {
      this.poiInfo.rating = `${rating}`;
    }
    if (open == true) {
      this.poiInfo.open = `${this._translate.instant('Yes')}`;
    } else {
      this.poiInfo.open = `${this._translate.instant('No')}`;
    }
    this.setDistanceAndETA(lat, lng);
    this.infoWindow.get(0)!.open(marker);
  }

  openUserLocationInfo(marker: any) {
    this._mapService
      .getAddressByLongitudinalCoordinates(this.center.lat, this.center.lng)
      .pipe(first())
      .subscribe({
        next: (addressInfo) => {
          this.userLocationInfo = addressInfo;
          this.infoWindow.get(1)!.open(marker);
        },
        error: (err) => {
          console.log(err);
        },
      });
  }

  openGoogleMaps() {
    openGoogleMaps(this.poiInfo.lat, this.poiInfo.lng);
  }
}
