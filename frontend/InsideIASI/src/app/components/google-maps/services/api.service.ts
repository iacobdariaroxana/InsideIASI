import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, map } from 'rxjs';
import { DistanceDTO, PointOfInterestDTO } from 'src/app/model';

@Injectable({
  providedIn: 'root',
})
export class ApiService {
  constructor(private readonly _httpClient: HttpClient) {}
  url: string = 'https://inside-iasi.azurewebsites.net/map';

  getPointsOfInterest(
    lat: number,
    long: number,
    query: string
  ): Observable<PointOfInterestDTO[]> {
    const httpOptions = { headers: new HttpHeaders() };
    httpOptions.headers.append('Access-Control-Allow-Origin', '*');
    httpOptions.headers.append('Content-Type', 'application/json');
    return this._httpClient
      .get(
        `${this.url}/pois?latitude=${lat}&longitude=${long}&query=${query}`,
        { responseType: 'json' }
      )
      .pipe(
        map<any, PointOfInterestDTO[]>((response) => {
          return response;
        })
      );
  }

  getDistanceBetweenPlaces(
    originLat: number,
    originLong: number,
    destLat: number,
    destLong: number
  ): Observable<DistanceDTO> {
    const httpOptions = { headers: new HttpHeaders() };
    httpOptions.headers.append('Access-Control-Allow-Origin', '*');
    httpOptions.headers.append('Content-Type', 'application/json');
    return this._httpClient
      .get(
        `${this.url}/distance?originLatitude=${originLat}&originLongitude=${originLong}&destLatitude=${destLat}&destLongitude=${destLong}`,
        { responseType: 'json' }
      )
      .pipe(
        map<any, DistanceDTO>((response) => {
          // console.log(response);
          return response;
        })
      );
  }
}
