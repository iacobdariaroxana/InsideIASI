import { AfterViewInit, Component, OnDestroy } from '@angular/core';
import { Location } from '@angular/common';
import { HourWeatherInfo } from 'src/app/model';
import { MatDialog } from '@angular/material/dialog';
import { WeatherDialogComponent } from 'src/app/components/weather-dialog/weather-dialog.component';
import { Dialog } from '@capacitor/dialog';
import { TranslateService } from '@ngx-translate/core';
import { DataService } from './services/data.service';
import { Haptics } from '@capacitor/haptics';
import { AppLauncher } from '@capacitor/app-launcher';

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
    // setTimeout(() => {
    //   this.hoursWeatherInfo = this._dataService.getHoursWeatherInfo();
    // }, 1500);
    // if (this._dataService.getHourFlag()) {
    //   setTimeout(() => {
    //     this.checkWeatherAlert();
    //   }, 3000);
    // }
    // this.weatherIntervalId = setInterval(() => {
    //   this.hoursWeatherInfo = this._dataService.getHoursWeatherInfo();
    //   this.checkWeatherAlert();
    // }, 3600000);
  }

  async triggerAlert(key: string) {
    await Haptics.vibrate({ duration: 1000 });
    this._translate.get(key).subscribe((message) => {
      this.weatherAlertMessage = message;
      this.showWeatherAlert();
    });
  }

  async checkWeatherAlert() {
    if (this.hoursWeatherInfo.length < 1) return;
    if (this.hoursWeatherInfo[1].values.precipitationProbability > 50) {
      this.triggerAlert('WeatherAlertRainMessage');
    } else if (this.hoursWeatherInfo[1].values.temperature > 35) {
      this.triggerAlert('WeatherAlertHighMessage');
    } else if (this.hoursWeatherInfo[1].values.temperature < 0) {
      this.triggerAlert('WeatherAlertLowMessage');
    }
  }

  openWeatherDialog() {
    if (this.hoursWeatherInfo.length != 0) {
      this._dialogRef.open(WeatherDialogComponent, {
        hasBackdrop: true,
        data: this.hoursWeatherInfo,
        panelClass: 'dialog',
      });
    }
  }

  async openARApp() {
    await AppLauncher.openUrl({ url: 'com.example.iasi_ar' });
  }

  goBack() {
    this.location.back();
  }

  ngOnDestroy(): void {
    clearInterval(this.weatherIntervalId);
  }
}
