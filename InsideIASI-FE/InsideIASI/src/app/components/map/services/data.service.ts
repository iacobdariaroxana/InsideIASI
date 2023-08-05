import { Injectable, OnDestroy, OnInit } from '@angular/core';
import { HourWeatherInfo } from 'src/app/model';
import { WeatherService } from './weather.service';

@Injectable({
  providedIn: 'root',
})
export class DataService implements OnDestroy {
  hoursWeatherInfo: HourWeatherInfo[] = [];
  dataInterval: NodeJS.Timer;
  hourFlag: boolean = true;

  constructor(private readonly _weatherService: WeatherService) {
    this.getCurrentWeather();
    this.dataInterval = setInterval(() => {
      this.hourFlag = true;
      this.getCurrentWeather();
    }, 3540000);
  }

  getCurrentWeather() {
    this._weatherService.getCurrentWeather().subscribe((response) => {
      const intervals = response.data.timelines[0].intervals;
      this.hoursWeatherInfo = intervals.map((interval) => {
        return {
          startTime: new Date(interval.startTime),
          values: {
            humidity: interval.values.humidity,
            precipitationProbability: interval.values.precipitationProbability,
            temperature: interval.values.temperature,
          },
        };
      });
    });
  }

  getHoursWeatherInfo(): HourWeatherInfo[] {
    return this.hoursWeatherInfo;
  }

  getHourFlag(): boolean {
    if (this.hourFlag == true) {
      this.hourFlag = false;
      return true;
    }
    return this.hourFlag;
  }

  ngOnDestroy(): void {
    clearInterval(this.dataInterval);
  }
}
