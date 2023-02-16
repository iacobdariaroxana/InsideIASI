import { AfterViewInit, Component, OnInit, ViewChild } from '@angular/core';
import { GoogleMap, MapInfoWindow } from '@angular/google-maps';
import { first } from 'rxjs';
import { Marker, MarkerInfo } from 'src/app/model';
import { MapService } from './services/map.service';
import { Geolocation } from '@capacitor/geolocation';
import { ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';
import { captureImage, openGoogleMaps } from './utils';
import { ImageService } from './services/image.service';
import { Camera, CameraResultType } from '@capacitor/camera';

@Component({
  selector: 'app-map',
  templateUrl: './map.component.html',
  styleUrls: ['./map.component.css'],
})
export class MapComponent implements OnInit, AfterViewInit {
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
    // minZoom: 12.5,
  };
  info: MarkerInfo = { name: '', rating: '', lat: 0, lng: 0 };

  constructor(
    private readonly _mapService: MapService,
    private readonly _route: ActivatedRoute,
    private location: Location,
    private readonly _imageService: ImageService
  ) {}

  ngOnInit(): void {
    this.setCurrentPosition();

    this._route.queryParams.subscribe((params) => {
      this.getMarkers(params['query']);
    });
  }

  ngAfterViewInit(): void {}

  setCurrentPosition = async () => {
    await Geolocation.getCurrentPosition()
      .then((response) => {
        this.center = {
          lat: response.coords.latitude,
          lng: response.coords.longitude,
        };
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

  async captureImage() {
    const image = await Camera.getPhoto({
      quality: 90,
      allowEditing: false,
      resultType: CameraResultType.Base64,
    });
    // console.log(image.base64String);
    this._imageService
      .getImagePlace(image.base64String!)
      .pipe(first())
      .subscribe({
        next: (response) => {
          console.log(response);
        },
        error: (err) => {
          console.log(err);
        },
      });
  }

  getMarkers(query: string) {
    // this.center.lat, this.center.long
    this._mapService
      .getPointsOfInterest(47.17778798149116, 27.57176764209399, query)
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
            };
          });
          console.log(this.markers);
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
    lng: number
  ) {
    this.info.name = name;
    rating == 0 ? (this.info.rating = '-') : (this.info.rating = `${rating}`);
    this.info.lat = lat;
    this.info.lng = lng;
    this.infoWindow.open(marker);
  }

  goBack() {
    this.location.back();
  }

  openGoogleMaps() {
    openGoogleMaps(this.info.lat, this.info.lng);
  }
}
