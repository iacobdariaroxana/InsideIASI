import { Component } from '@angular/core';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { HourWeatherInfo } from '../../model';
import { Inject } from '@angular/core';

@Component({
  selector: 'app-weather-dialog',
  templateUrl: './weather-dialog.component.html',
  styleUrls: ['./weather-dialog.component.scss'],
})
export class WeatherDialogComponent {
  weatherOnHours: HourWeatherInfo[];
  constructor(@Inject(MAT_DIALOG_DATA) public data: HourWeatherInfo[]) {
    this.weatherOnHours = data;
  }
}
