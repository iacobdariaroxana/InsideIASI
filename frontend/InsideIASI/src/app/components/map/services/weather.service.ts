import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class WeatherService {
  url =
    'https://api.tomorrow.io/v4/timelines?apikey=';
  constructor(private readonly _httpClient: HttpClient) {}

  getCurrentWeather() {
    return this._httpClient.post<{
      data: {
        timelines: [
          {
            timestep: string;
            endTime: string;
            startTime: Date;
            intervals: [
              {
                startTime: string;
                values: {
                  humidity: number;
                  precipitationProbability: number;
                  temperature: number;
                };
              }
            ];
          }
        ];
      };
    }>(`${this.url}`, {
      location: '641d5209ed2f49c918254ecc',
      fields: ['temperature', 'humidity', 'precipitationProbability'],
      units: 'metric',
      timesteps: ['1h'],
      startTime: 'now',
      endTime: 'nowPlus6h',
    });
  }
}
