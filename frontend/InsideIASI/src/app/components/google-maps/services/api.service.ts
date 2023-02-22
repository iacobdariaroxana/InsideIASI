import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, map } from 'rxjs';
import { PointOfInterestDTO } from 'src/app/model';

@Injectable({
  providedIn: 'root',
})
export class ApiService {
  constructor(private readonly _httpClient: HttpClient) {}

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
        `http://192.168.136.121:5002/Map?latitude=${lat}&longitude=${long}&query=${query}`,
        { responseType: 'json' }
      )
      .pipe(
        map<any, PointOfInterestDTO[]>((response) => {
          // console.log(`Api service: ${response}`);
          return response;
        })
      );
  }
}
