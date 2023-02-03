import { AfterViewInit, Component, OnInit, ViewChild } from '@angular/core';
import { GoogleMap, MapInfoWindow } from '@angular/google-maps';
import { Camera, CameraResultType } from '@capacitor/camera';
import { first } from 'rxjs';
import { Marker } from 'src/app/model';
import { MapService } from './services/map.service';
import { Geolocation } from '@capacitor/geolocation';
import { ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';

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

  namePOI: string = '';
  ratingPOI: string = '';

  constructor(
    private readonly _mapService: MapService,
    private readonly _route: ActivatedRoute,
    private location: Location
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
  }

  getMarkers(query: string) {
    // this.center.lat, this.center.long
    console.log(query);
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

  openInfo(marker: any, name: string, rating: number) {
    this.namePOI = name;
    rating == 0? this.ratingPOI = '-' : this.ratingPOI = `${rating}`;
    // this.ratingPOI = `${rating}`;
    this.infoWindow.open(marker);
  }

  goBack() {
    this.location.back();
  }
}
