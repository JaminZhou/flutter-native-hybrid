package com.jaminzhou.example;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import java.lang.ref.WeakReference;

public class MainActivity extends AppCompatActivity  {

    public static WeakReference<MainActivity> sRef;

    private ListView listView;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        sRef = new WeakReference<>(this);

        setContentView(R.layout.activity_main);

        listView = findViewById(R.id.listView);

        String[] values = new String[] {
                "flutter page1",
                "flutter page2",
            };

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, android.R.id.text1, values);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                switch (position) {
                    case 0:
                        tapFlutterPgae1();
                        break;
                    case 1:
                        tapFlutterPgae2();
                        break;
                        default:
                            break;
                }
            }
        });
    }

    void tapFlutterPgae1() {
        startActivity(new Intent(this, FlutterPage1.class));
        oops();
    }

    void tapFlutterPgae2() {
        startActivity(new Intent(this, FlutterPage2.class));
        oops();
    }

    /*
    something wrong
    like: https://github.com/alibaba/flutter_boost/issues/196
          https://github.com/alibaba/flutter_boost/issues/201
    */
    void oops() {
        listView.setY(210);
    }
}
