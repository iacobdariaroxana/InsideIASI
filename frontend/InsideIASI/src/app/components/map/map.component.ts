import { AfterViewInit, Component, OnDestroy, OnInit } from '@angular/core';
import { first } from 'rxjs';
import { Location } from '@angular/common';
import { ImageService } from './services/image.service';
import { Camera, CameraResultType } from '@capacitor/camera';
import { HourWeatherInfo } from 'src/app/model';
import { MatDialog } from '@angular/material/dialog';
import { WeatherDialogComponent } from 'src/app/components/weather-dialog/weather-dialog.component';
import { Dialog } from '@capacitor/dialog';
import { TranslateService } from '@ngx-translate/core';
import { DataService } from './services/data.service';

@Component({
  selector: 'app-map',
  templateUrl: './map.component.html',
  styleUrls: ['./map.component.scss'],
})
export class MapComponent implements AfterViewInit, OnDestroy {
  hoursWeatherInfo: HourWeatherInfo[] = [];
  weatherIntervalId!: NodeJS.Timer;
  weatherAlertTitle!: string;
  weatherAlertMessage!: string;
  weatherAlertButton!: string;
  readonly showWeatherAlert = async () => {
    await Dialog.alert({
      title: this.weatherAlertTitle,
      message: this.weatherAlertMessage,
      buttonTitle: this.weatherAlertButton,
    });
  };

  constructor(
    private location: Location,
    private readonly _imageService: ImageService,
    private _dialogRef: MatDialog,
    private _translate: TranslateService,
    private _dataService: DataService
  ) {
    this._translate
      .get('WeatherAlertTitle')
      .subscribe((title) => (this.weatherAlertTitle = title));
    this._translate
      .get('WeatherAlertButton')
      .subscribe((buttonText) => (this.weatherAlertButton = buttonText));
  }

  ngAfterViewInit(): void {
    // if (this._dataService.getHourFlag()) {
    //   setTimeout(() => {
    //     this.hoursWeatherInfo = this._dataService.getHoursWeatherInfo();
    //     this.checkWeatherAlert();
    //   }, 3000);
    // }
    // this.weatherIntervalId = setInterval(() => {
    //   this.hoursWeatherInfo = this._dataService.getHoursWeatherInfo();
    //   this.checkWeatherAlert();
    // }, 3600000);
  }

  async captureImage() {
    const image = await Camera.getPhoto({
      quality: 70,
      allowEditing: false,
      resultType: CameraResultType.Base64,
    });
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

  checkWeatherAlert() {
    if (this.hoursWeatherInfo[1].values.precipitationProbability > 50) {
      this._translate.get('WeatherAlertRainMessage').subscribe((message) => {
        this.weatherAlertMessage = message;
        this.showWeatherAlert();
      });
    } else if (this.hoursWeatherInfo[1].values.temperature > 35) {
      this._translate.get('WeatherAlertHighMessage').subscribe((message) => {
        this.weatherAlertMessage = message;
        this.showWeatherAlert();
      });
    } else if (this.hoursWeatherInfo[1].values.temperature < 0) {
      this._translate.get('WeatherAlertLowMessage').subscribe((message) => {
        this.weatherAlertMessage = message;
        this.showWeatherAlert();
      });
    }
  }

  openDialog() {
    if (this.hoursWeatherInfo.length != 0) {
      this._dialogRef.open(WeatherDialogComponent, {
        hasBackdrop: true,
        data: this.hoursWeatherInfo,
        panelClass: 'dialog',
      });
    }
  }

  goBack() {
    this.location.back();
  }

  ngOnDestroy(): void {
    clearInterval(this.weatherIntervalId);
  }
}
