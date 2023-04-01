import { AfterViewInit, Component, OnInit } from '@angular/core';
import { first } from 'rxjs';
import { Location } from '@angular/common';
import { ImageService } from './services/image.service';
import { Camera, CameraResultType } from '@capacitor/camera';
import { WeatherService } from './services/weather.service';
import { HourWeatherInfo } from 'src/app/model';
import { MatDialog } from '@angular/material/dialog';
import { WeatherDialogComponent } from 'src/app/components/weather-dialog/weather-dialog.component';

@Component({
  selector: 'app-map',
  templateUrl: './map.component.html',
  styleUrls: ['./map.component.scss'],
})
export class MapComponent implements OnInit, AfterViewInit {
  hoursWeatherInfo: HourWeatherInfo[] = [];
  constructor(
    private location: Location,
    private readonly _imageService: ImageService,
    private readonly _weatherService: WeatherService,
    private _dialogRef: MatDialog
  ) {}

  ngOnInit(): void {}

  ngAfterViewInit(): void {}

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

  goBack() {
    this.location.back();
  }

  getCurrentWeather() {
    this._weatherService
      .getCurrentWeather()
      .subscribe((response) => {
        const intervals = response.data.timelines[0].intervals;
          this.hoursWeatherInfo = intervals.map((interval) => {
            return {
              startTime: new Date(interval.startTime),
              values: {
                humidity: interval.values.humidity,
                precipitationProbability:
                  interval.values.precipitationProbability,
                temperature: interval.values.temperature,
              },
            };
          });
          if (this.hoursWeatherInfo.length != 0) {
            this.openDialog();
          }
      }
      );
  }

  openDialog() {
    this._dialogRef.open(WeatherDialogComponent, {
      hasBackdrop: true,
      data: this.hoursWeatherInfo,
      panelClass: 'dialog',
    });
  }
}
