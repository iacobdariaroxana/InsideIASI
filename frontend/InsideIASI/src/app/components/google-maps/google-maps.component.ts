import { Component, OnInit, ViewChild } from '@angular/core';
import { GoogleMap, MapInfoWindow } from '@angular/google-maps';
import { first } from 'rxjs';
import { Marker, MarkerInfo } from 'src/app/model';
import { MapService } from './services/map.service';
import { Geolocation } from '@capacitor/geolocation';
import { ActivatedRoute } from '@angular/router';
import { openGoogleMaps } from './utils';
import { TranslateService } from '@ngx-translate/core';

@Component({
  selector: 'app-google-maps',
  templateUrl: './google-maps.component.html',
  styleUrls: ['./google-maps.component.css'],
})
export class GoogleMapsComponent implements OnInit {
  @ViewChild(GoogleMap) map!: GoogleMap;
  @ViewChild(MapInfoWindow) infoWindow!: MapInfoWindow;

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
  info: MarkerInfo = { name: '', rating: '', lat: 0, lng: 0, open: '' };

  constructor(
    private readonly _mapService: MapService,
    private readonly _route: ActivatedRoute,
    public translate: TranslateService
  ) {}

  ngOnInit(): void {
    this.setCurrentPosition();

    this._route.queryParams.subscribe((params) => {
      this.getMarkers(params['query']);
    });
  }

  setCurrentPosition = async () => {
    await Geolocation.getCurrentPosition()
      .then((response) => {
        this.center = {
          lat: response.coords.latitude,
          lng: response.coords.longitude,
        };
        // console.log(this.center);
        const userLocationMarker = new google.maps.Marker({
          position: this.center,
        });
        if (this.map.googleMap) {
          userLocationMarker.setMap(this.map.googleMap);
        }
      })
      .catch(async (err) => {
        console.log(err);
      });
  };

  getMarkers(query: string) {
    // this.center.lat, this.center.long
    this._mapService
      .getPointsOfInterest(47.17778798149116, 27.57176764209399, query)
      .pipe(first())
      .subscribe({
        next: (pointsOfInterest) => {
          console.log(pointsOfInterest);
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
          // console.log(this.markers);
        },
        error: (err) => {
          console.log(err);
        },
      });
  }

  openInfo(
    marker: any,
    name: string,
    rating: number,
    lat: number,
    lng: number,
    open: boolean
  ) {
    this.info.name = name;
    rating == 0 ? (this.info.rating = '-') : (this.info.rating = `${rating}`);
    this.info.lat = lat;
    this.info.lng = lng;
    open == undefined ? (this.info.open = '-') : (this.info.open = `${open}`);
    if(open == undefined){
      this.info.open = '-';
    } else if(open == true){
      this.info.open = `${this.translate.instant('Yes')}`;
    } else {
      this.info.open = `${this.translate.instant('No')}`;
    }
    this.infoWindow.open(marker);
  }

  openGoogleMaps() {
    openGoogleMaps(this.info.lat, this.info.lng);
  }
}
